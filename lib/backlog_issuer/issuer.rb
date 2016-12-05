module BacklogIssuer
  class Issuer
    def initialize(client, parser)
      @client = client
      @parser = parser
    end

    def execute
      @parser.issues.each do |issue|
        params = make_issue_params(issue)        
        issue_id = @client.issue_by_summary(issue.summary)
        if issue_id.nil?
          @client.add_issue(issue.summary, params)
        else
          params[:summary] = issue.summary
          @client.update_issue(issue_id, params)
        end
      end
    end

    def make_issue_params(issue)
      params = {}
      params[:issueTypeId] = @client.issue_type_id(issue.issue_type) unless issue.issue_type.nil?
      params[:priorityId] = @client.priority_id(issue.priority) unless issue.priority.nil?
      params[:categoryId] = [@client.category_id(issue.category)] unless issue.category.nil?
      params[:milestoneId] = [@client.milestone_id(issue.milestone)] unless issue.milestone.nil?

      unless issue.parent_issue.nil?
        params[:parentIssueId] = @client.issue_id(issue.parent_issue)
      else
        params[:parentIssueId] = ''
      end

      unless issue.assignee.nil?
        params[:assigneeId] = @client.assignee_id(issue.assignee)
      else
        params[:assigneeId] = ''
      end

      params[:description] = issue.description unless issue.description.nil?
      params[:startDate] = issue.start_date unless issue.start_date.nil?
      params[:dueDate] = issue.due_date unless issue.due_date.nil?
      params
    end
  end
end
