Feature: Gitlr

	Scenario: listing repositories
	    When using mock `repos.txt`
		And I run `gitlr query org repos`
		Then it should pass with:
			"""
			gitlr
			"""
