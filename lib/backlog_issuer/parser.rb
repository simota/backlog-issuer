# coding: utf-8
require 'csv'
require 'date'
require 'ostruct'

module BacklogIssuer

  class Parser

    HEADERS = {
      '種別' => :issue_type,
      '優先度' => :priority,
      'カテゴリー' => :category,
      'マイルストーン' => :milestone,
      '親課題' => :parent_issue,
      '件名' => :summary,
      '詳細' => :description,
      '担当者' => :assignee,
      '開始日' => :start_date,
      '期限日' => :due_date
    }

    def initialize(csvfile)
      @csvfile = csvfile
    end

    def issues
      @issues ||= make_issues
      @issues
    end

    def make_issues
      issues = []
      CSV.foreach(@csvfile, encoding: "SJIS:UTF-8") do |row|
        if @column_map.nil?
          @column_map = make_column_map(row)
          next
        end
        issue = make_issue(row)
        issues << issue unless issue.summary.nil?
      end
      issues
    end

    def make_column_map(row)
      column_map = {}
      row.each_with_index do |r, i|
        column_map[HEADERS[r]] = i
      end
      column_map
    end

    def make_issue(row)
      start_date = parse_date(row[@column_map[:start_date]])
      due_date = parse_date(row[@column_map[:due_date]])
      OpenStruct.new(
        {
          issue_type: row[@column_map[:issue_type]],
          priority: row[@column_map[:priority]],
          category: row[@column_map[:category]],
          milestone: row[@column_map[:milestone]],
          parent_issue: row[@column_map[:parent_issue]],
          summary: row[@column_map[:summary]],
          description: row[@column_map[:description]],
          assignee: row[@column_map[:assignee]],
          start_date: start_date,
          due_date: due_date
        })
    end

    private
    def parse_date(str)
      begin
        date = Date.parse(str)
        date.strftime('%Y-%m-%d')
      rescue
        nil
      end
    end
  end
end
