module Gitlr

    class Data
        attr_reader :client

        def initialize
            # For debugging what going on under the hood
            if (Gitlr.configuration.debug)
                stack = Faraday::RackBuilder.new do |builder|
                    builder.response :logger
                    builder.use Octokit::Response::RaiseError
                    builder.adapter Faraday.default_adapter
                end
                Octokit.middleware = stack
            end
            @client = Octokit::Client.new(:netrc => true)
            @client.login
            @client.auto_paginate = true

        end

        # Repositories

        def repos
            return handle_response(@client.organization_repositories(Gitlr.configuration.organization))
        end

        def missing_repos(team_id)
            res = Array.new
            repos_response = repos()
            team_repos_response = team_repos(team_id)
            repos_response.each { |repo|
                hit = false
                team_repos_response.each { |team_repo|
                    if (repo[:full_name] == team_repo[:full_name])
                        hit = true
                    end
                }
                res << repo unless hit
            }
            return res
        end

        # TODO Introduce controller layer where this can be done
        def copy_repos_from_team_to_team(team_id, team_id2)
            first = team_repos(team_id)
            second = team_repos(team_id2)

            first.each { |r1|
                hit = false
                second.each { |r2|
                    if (r1[:full_name] == r2[:full_name])
                        hit = true
                    end
                }

                if (!hit)
                    print "#{r1[:full_name]} is not in the target team. Add it? [y/N] : "
                    answer = STDIN.gets.chomp
                    if (answer == 'y')
                        res = add_team_repo(team_id2, r1[:full_name])
                        if (res)
                            print "Added #{r1[:full_name]} to team #{team_id2}\n\n"
                        else
                            print "Could not #{r1[:full_name]} to team #{team_id2}\n\n"
                        end
                    else
                        print "Skipping #{r1[:full_name]}...\n"
                    end
                end
            }
        end

        def compare_team_repos(team_id, team_id2)
            res = ""
            count = 0
            first = team_repos(team_id)
            second = team_repos(team_id2)

            first.each { |r1|
                hit = false
                second.each { |r2|
                    if (r1[:full_name] == r2[:full_name])
                        hit = true
                    end
                }
                count = count + 1 unless hit
                res = res + "#{r1[:full_name]} (#{r1[:id]}) is missing from second team\n" unless hit
                #res = res + "#{r1[:full_name]} exists for both teams \n" if hit
            }

            second.each { |r1|
                hit = false
                first.each { |r2|
                    if (r1[:full_name] == r2[:full_name])
                        hit = true
                    end
                }
                count = count + 1 unless hit
                res = res + "#{r1[:full_name]} (#{r1[:id]}) is missing from first team\n" unless hit
            }

            if (count == 0)
                res = res + "The two teams has access to the same repositories!"
            else
                res = res + "#{count} differenctes betweeen the two teams."
            end
            return res
        end

        # Teams


        def teams
            return handle_response(@client.organization_teams(Gitlr.configuration.organization))
        end

        def team_repos(team_id)
            return handle_response(@client.team_repositories(team_id))
        end

        def add_team_repo(team_id, repo)
            return @client.add_team_repository(team_id, repo)
        end

        # Members

        def members
            return handle_response(@client.organization_members(Gitlr.configuration.organization))
        end


        def handle_response(response)
            # if (Gitlr.configuration.debug)
            #     puts response
            # else
            #     response.each { |e|
            #         print_obj e
            #     }
            # end
            return response
        end

        # def print_obj(obj)
        #     s = ''
        #     obj.fields.each { |f|
        #         s << f.to_s << ':' << obj[f].to_s << " ; "
        #     }
        #     s << "\n"
        #     puts s
        #
        # end
        #
        # def dump_fields(obj)
        #     puts obj.fields
        # end

    end

end