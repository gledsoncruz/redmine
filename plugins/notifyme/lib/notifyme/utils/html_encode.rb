module Notifyme
  module Utils
    class HtmlEncode
      def self.encode(str)
        b = ''
        str.each_char do |c|
          b << if c.ord < 128
                 c
               else
                 HTMLEntities.new.encode(c, :named)
               end
        end
        b
      end
    end
  end
end
