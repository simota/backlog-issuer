require 'backlog_kit'
require "digest/md5"

module BacklogIssuer
  class Client
    def initialize(space_id, api_key)
      @space_id = space_id
      @api_key = api_key
      @backlog = BacklogKit::Client.new(
        space_id: space_id,
        api_key: api_key
      )
    end

    def project_key=(project_key)
      @project ||= @backlog.get_project(project_key).body
      @issue_types ||= @backlog.get_issue_types(@project.id).body
    end

    def project
      @project
    end

    def priority_id(name)
      @priorities ||= @backlog.get_priorities.body
      priority = @priorities.find {|x| x.name == name}
      priority.id unless priority.nil?
    end

    def project_issues
      if @project_issues.nil?
        issue_count = @backlog.get_issue_count({projectId: [project.id]}).body.count
        pages = (issue_count.to_f / 100.0).ceil
        issues = []
        1.upto(pages).each do |page|
          issues += @backlog.get_issues({projectId: [project.id], count: 100, offset: (page - 1) * 100}).body
        end

        @project_issues = issues
      end
      @project_issues
    end

    def issue_by_summary(summary)
      issue = project_issues.find {|i| i.summary == summary}
      issue.id unless issue.nil?
    end

    def issue_id(issue_key)
      @issues ||= {}
      @issues[issue_key] ||= @backlog.get_issue(issue_key).body
      @issues[issue_key].id
    end

    def issue_types
      @issue_types
    end

    def issue_type_id(name)
      issue_type = @issue_types.find {|t| t.name == name}
      issue_type.id unless issue_type.nil?
    end

    def assignee_id(name)
      @users ||= @backlog.get_project_users(project.projectKey).body
      user = @users.find {|u| u.name == name}
      user.id unless user.nil?
    end

    def category_id(name)
      @categories ||= @backlog.get_categories(project.projectKey).body
      category = @categories.find {|c| c.name == name}
      category.id unless category.nil?
    end

    def milestone_id(name)
      @milestones ||= @backlog.get_versions(project.projectKey).body
      milestone = @milestones.find {|m| m.name == name}
      milestone.id unless milestone.nil?
    end

    def add_issue(summary, params)
      params[:projectId] = project.id
      @backlog.create_issue(summary, params)
    end

    def update_issue(issue_id, params)
      @backlog.update_issue(issue_id, params)
    end

    def delete_issue(issue_key)
      @backlog.delete_issue(issue_key)
    end

    def delete_issues(issue_keys)
      issue_keys.each {|key| @backlog.delete_issue(key)}
    end

  end
end
