require 'csv'

class Main
  attr_reader :bills,
              :legislators,
              :votes,
              :vote_results,
              :legislator_votes,
              :bill_votes

  def initialize
    @bills = parse_csv('bills')
    @legislators = parse_csv('legislators')
    @votes = parse_csv('votes')
    @vote_results = parse_csv('vote_results')

    @legislator_votes = {}
    @bill_votes = {}
  end

  def call
    calculate_legislator_votes
    calculate_bill_votes

    generate_legislator_votes_csv
    generate_bill_votes_csv
  end

  private

  def parse_csv(file)
    CSV.read("fixtures/#{file}.csv", headers: true).map(&:to_h)
  end

  def calculate_legislator_votes
    vote_results.each do |result|
      legislator_id = result['legislator_id']
      vote_type = result['vote_type']

      legislator_votes[legislator_id] ||= { 'supported' => 0, 'opposed' => 0 }

      legislator_votes[legislator_id]['supported'] += 1 if vote_type == '1'
      legislator_votes[legislator_id]['opposed'] += 1 if vote_type == '2'
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

  def generate_legislator_votes_csv
    CSV.open('legislators-support-oppose-count.csv', 'w') do |csv|
      csv << %w[id name num_supported_bills num_opposed_bills]

      legislators.each do |legislator|
        id = legislator['id']
        name = legislator['name']

        vote = legislator_votes[id] || {}

        supported = vote.dig('supported') || 0
        opposed = vote.dig('opposed') || 0

        csv << [id, name, supported, opposed]
      end
    end
  end

  def generate_bill_votes_csv
    CSV.open('bills.csv', 'w') do |csv|
      csv << %w[id title supporter_count opposer_count primary_sponsor]

      bills.each do |bill|
        id = bill['id']
        title = bill['title']

        vote = bill_votes[id] || {}

        supporters = vote.dig('supporters') || 0
        opposers = vote.dig('opposers') || 0
        primary_sponsor = vote.dig('primary_sponsor') || 'Unknown'

        csv << [id, title, supporters, opposers, primary_sponsor]
      end
    end
  end
end

Main.new.call
