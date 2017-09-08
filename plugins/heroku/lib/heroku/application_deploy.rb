module Heroku
  class ApplicationDeploy
    def initialize(app)
      @app = app
      @branch = nil
    end

    def run
      b = Buffer.new
      [:show_info, :update_workcopy, :check_source_branch, :check_source_updated,
       :login, :git_remote_set, :deploy, :configure_app_version, :update_last_deploy_commit,
       :telegram_notify].each do |method|
        unless send(method, b)
          Rails.logger.debug(b.to_s)
          break
        end
      end
    end

    def self.check_commands
      %w(heroku expect).each do |command|
        next if which(command)
        raise "Comando \"#{command}\" não encontrado"
      end
    end

    def self.which(cmd)
      exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each do |ext|
          exe = File.join(path, "#{cmd}#{ext}")
          return exe if File.executable?(exe) && !File.directory?(exe)
        end
      end
      nil
    end

    private

    def show_info(b)
      b << "Aplicação: #{@app.name}"
      b << "Repositório Git: #{@app.repository}"
      b << "Último commit instalado: \"#{@app.last_deploy_commit}\""
      b << "Ativa: #{@app.active}"
      @app.active
    end

    def update_workcopy(_b)
      workcopy.update
      true
    end

    def check_source_branch(b)
      if workcopy.source_branch_revision
        b << "Branch-fonte encontrado: #{workcopy.source_branch_revision}"
        b << "Versão: #{workcopy.app_version}"
        true
      else
        b << "Branch-fonte \"#{@app.source_branch}\" não-encontrado"
        false
      end
    end

    def check_source_updated(b)
      if workcopy.source_updated?
        true
      else
        b << 'Revisão já está instalada'
        false
      end
    end

    def login(b)
      r = workcopy.heroku_login
      b << "Login no Heroku para \"#{@app.account.username}\": #{r ? 'ok' : 'failed'}"
      r
    end

    def git_remote_set(b)
      r = workcopy.heroku_set_remote
      b << "Heroku git remote \"#{@app.name}\": #{r ? 'ok' : 'failed'}"
      b << "App URL: #{workcopy.heroku_app_url}" if r
      r
    end

    def deploy(b)
      r = workcopy.heroku_deploy
      b << "Deploy: #{r ? 'ok' : 'failed'}"
      r
    end

    def update_last_deploy_commit(_b)
      @app.last_deploy_commit = workcopy.source_branch_revision
      @app.save!
    end

    def configure_app_version(_b)
      workcopy.heroku_set_git_revision_as_app_version
    end

    def telegram_notify(b)
      Notifyme::Notify.notify(content_type: :plain, content: b.to_s, author: nil)
    end

    def workcopy
      @workcopy ||= Workcopy.new(@app)
    end

    class Buffer
      def initialize
        @b = ''
      end

      def <<(s)
        @b << "#{s}\n"
      end

      def to_s
        @b
      end
    end
  end
end
