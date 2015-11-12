module Gitlr

  class Render
    attr_reader :format

    def initialize(format)
      @format = format
    end

    def render_repos(repos)
      if @format.to_s == 'id'
        fi = [/full_name/]
      else
        fi = [/full_name/, /language$/, /description/]
      end
      render_array(repos, Gitlr::RenderStrategy.new('include', fi))
    end

    def render_missing_repos(repos)
      if @format.to_s == 'id'
        fi = [/full_name/]
      else
        fi = [/full_name/, /language$/, /description/]
      end
      render_array(repos, Gitlr::RenderStrategy.new('include', fi))
    end

    def render_compare_team_repos(result)
      puts result
    end

    def render(result)
      render_object(result, Gitlr::RenderStrategy.new('none', []))
    end

    def render_teams(teams)
      render_array(teams, Gitlr::RenderStrategy.new('exclude', [/(.*)url/]))
    end

    def render_members(members)
      render_array(members, Gitlr::RenderStrategy.new('exclude', [/(.*)url/]))
    end

    ##############################
    private
    ##############################

    def render_array(response, strategy)
      result = render_csv_array(response, strategy)
      if @format.to_s == 'csv' || @format.to_s == 'id'
        puts result
      else
        puts render_pretty_array(result)
      end
    end

    def render_object(response, strategy)
      result = render_csv_object(response, strategy)
      if @format.to_s == 'csv' || @format.to_s == 'id'
        puts result
      else
        puts render_pretty_array(result)
      end
    end


    def render_csv_array(response, strategy)
      result = Array.new
      first_iteration = true
      response.each { |obj|
        unless obj.description.nil?
          obj.description = obj.description[0..147] + "..." if obj.description.length > 150
        end
        if first_iteration && Gitlr.configuration.show_header
          arr = Array.new
          obj.fields.each { |field|
            arr << field.to_s unless ignore_field?(field, strategy)
          }
          first_iteration = false
          result << arr.join(';')
        end
        row = []
        obj.fields.each { |field|
          row << obj[field] unless ignore_field?(field, strategy)
        }
        result << row.join(';')

      }
      result
    end

    def render_csv_object(response, strategy)
      result = Array.new
      row = []
      head = []
      response.fields.each { |field|
        head << field.to_s if Gitlr.configuration.show_header
        row << response[field] unless ignore_field?(field, strategy)
      }
      result << head.join(';') if Gitlr.configuration.show_header
      result << row.join(';')
      result
    end

    def ignore_field?(field, strategy)
      if strategy == 'none'
        false
      elsif strategy.strategy == 'include'
        strategy.fields.each { |f|
          if f.match(field)
            return false
          end
        }
        true
      else
        strategy.fields.each { |f|
          if f.match(field)
            return true
          end
        }
        false
      end
    end


    def render_pretty_array(csv)
      rows = []
      header = []
      first_iteration = true
      csv.each { |line|
        line_arr = line.split(';')
        if first_iteration && Gitlr.configuration.show_header
          first_iteration = false
          header = line_arr
        else
          rows << line_arr
        end
      }
      if Gitlr.configuration.show_header
        Terminal::Table.new :headings => header, :rows => rows
      else
        Terminal::Table.new :rows => rows
      end
    end

  end

  class RenderStrategy
    attr_reader :strategy, :fields

    def initialize(strategy, fields)
      @strategy = strategy
      @fields = fields
    end

  end

end
