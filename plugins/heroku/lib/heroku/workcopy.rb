module Heroku
  class Workcopy
    include ::Heroku::Workcopy::HerokuExtension
    include ::Heroku::Workcopy::GitExtension

    attr_reader :app

    def initialize(app)
      @app = app
    end

    def directory
      @directory ||= Directory.new(
        File.expand_path(
          "~/.cache/redmine/repositories/#{app.repository.git_access_path}"
        )
      )
    end
  end
end
