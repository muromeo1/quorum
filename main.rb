require 'csv'
require 'pry'

class Main
  attr_reader :bills,
              :legislators,
              :votes,
              :vote_results,
              :legislators_votes,
              :bill_counts

  def initialize
    @bills = parse_csv('bills')
    @legislators = parse_csv('legislators')
    @votes = parse_csv('votes')
    @vote_results = parse_csv('vote_results')

    @legislators_votes = {}
    @bill_counts = {}
  end

  def call
    calculate_legislators_votes
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
end

Main.new.call
