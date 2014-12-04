module Gitlr

    class Render
        attr_reader :format

        def initialize(format)
            @format = format
        end

        def render_repos(repos)
            render(repos, Gitlr::RenderStrategy.new('include', [/id/, /name/, /description/, /private/ ]))
        end

        def render_missing_repos(repos)
            render(repos, Gitlr::RenderStrategy.new('include', [/id/, /name/, /description/, /private/ ]))
        end

        def render_compare_team_repos(result)
            puts result
        end

        def render_teams(teams)
            render(teams, Gitlr::RenderStrategy.new('exclude', [/(.*)url/]))
        end

        def render_members(members)
            render(members, Gitlr::RenderStrategy.new('exclude', [/(.*)url/]))
        end

        ##############################
        private
        ##############################

        def render(response, strategy)
            result = render_csv(response, strategy)
            if (@format.to_s == 'csv')
                puts result
            else
                puts render_pretty(result)
            end
        end


        def render_csv(response, strategy)
            result = Array.new
            first_iteration = true
            response.each { |obj|
                if (first_iteration)
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

        def ignore_field?(field, strategy)
            if (strategy.strategy == 'include')
                strategy.fields.each { |f|
                    if (f.match(field))
                        return false
                    end
                }
                return true
            else
                strategy.fields.each { |f|
                    if (f.match(field))
                        return true
                    end
                }
                return false
            end
        end


        def render_pretty(csv)
            table = nil
            first_iteration = true
            csv.each { |line|
                line_arr = line.split(';')
                if (first_iteration)
                    table = Terminal::Table.new headings: line_arr
                    first_iteration = false
                else
                    table << line_arr
                end
            }
            table
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
