require 'diff_coverage'

RSpec.describe DiffCoverage do
  describe '.report' do
    it 'returns 100% when all changed lines are hit' do
      hits = { 'app/x.rb' => [nil, 1, 1, 1, nil] }
      diff = { 'app/x.rb' => [2, 3, 4] }
      result = described_class.report(hits, diff)
      expect(result['app/x.rb'][:percent]).to eq(100.0)
      expect(result['app/x.rb'][:covered]).to eq(3)
      expect(result['app/x.rb'][:total]).to eq(3)
    end

    it 'returns 0% when changed lines are unhit' do
      hits = { 'app/x.rb' => [nil, 0, 0, 0] }
      diff = { 'app/x.rb' => [2, 3] }
      expect(described_class.report(hits, diff)['app/x.rb'][:percent]).to eq(0.0)
    end

    it 'ignores nil hits (non-executable lines)' do
      hits = { 'app/x.rb' => [nil, nil, 1, 1] }
      diff = { 'app/x.rb' => [2, 3, 4] }
      result = described_class.report(hits, diff)['app/x.rb']
      expect(result[:total]).to eq(2)
      expect(result[:covered]).to eq(2)
      expect(result[:percent]).to eq(100.0)
    end

    it 'returns 100% when no changed lines are executable' do
      hits = { 'app/x.rb' => [nil, nil, nil] }
      diff = { 'app/x.rb' => [1, 2, 3] }
      expect(described_class.report(hits, diff)['app/x.rb'][:percent]).to eq(100.0)
    end
  end

  describe '.parse_diff_lines' do
    it 'parses git diff --unified=0 hunk headers' do
      diff_output = <<~DIFF
        diff --git a/app/x.rb b/app/x.rb
        @@ -1,2 +5,3 @@
        +new line
        +new line
        +new line
        @@ -10 +20 @@
        +another
      DIFF
      expect(described_class.parse_diff_lines(diff_output))
        .to eq('app/x.rb' => [5, 6, 7, 20])
    end
  end
end
