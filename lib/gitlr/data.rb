module Gitlr

    class Data
        attr_reader :client

        def initialize
            # For debugging what going on under the hood
            #stack = Faraday::RackBuilder.new do |builder|
            #    builder.response :logger
            #    builder.use Octokit::Response::RaiseError
            #    builder.adapter Faraday.default_adapter
            #end
            #Octokit.middleware = stack
            @client = Octokit::Client.new(:netrc => true)
            @client.login
            @client.auto_paginate = true

        end

        # Repositories

        def repos
            return handle_response(@client.organization_repositories(Gitlr.configuration.organization))
        end

        # Teams

        def teams
            return handle_response(@client.organization_teams(Gitlr.configuration.organization))
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
