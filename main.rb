require 'csv'
require 'pry'

class Main
  attr_reader :bills,
              :legislators,
              :votes,
              :vote_results,
              :legislators_votes,
              :bill_votes

  def initialize
    @bills = parse_csv('bills')
    @legislators = parse_csv('legislators')
    @votes = parse_csv('votes')
    @vote_results = parse_csv('vote_results')

    @legislators_votes = {}
    @bill_votes = {}
  end

  def call
    calculate_legislators_votes
    calculate_bill_votes
  end

  private

  def parse_csv(file)
    CSV.read("fixtures/#{file}.csv", headers: true).map(&:to_h)
  end

  def calculate_legislators_votes
    vote_results.each do |result|
      legislator_id = result['legislator_id']
      vote_type = result['vote_type']

      legislators_votes[legislator_id] ||= { 'supported' => 0, 'opposed' => 0 }

      legislators_votes[legislator_id]['supported'] += 1 if vote_type == '1'
      legislators_votes[legislator_id]['opposed'] += 1 if vote_type == '2'
    end
  end

  def calculate_bill_votes
    votes.each do |vote|
      bill_id = vote['bill_id']
      result = vote_results.find { |result| result['vote_id'] == vote['id'] }

      next if result.nil?

      legislator_id = result['legislator_id']
      vote_type = result['vote_type']

      bill_votes[bill_id] ||=
        { 'supporters' => 0, 'opposers' => 0, 'primary_sponsor' => nil }

      bill_votes[bill_id]['supporters'] += 1 if vote_type == '1'
      bill_votes[bill_id]['opposers'] += 1 if vote_type == '2'

      if legislators.find { |legislator| legislator['id'] == legislator_id }
        bill_votes[bill_id]['primary_sponsor'] = legislator_id
      end
    end
  end
end

Main.new.call
