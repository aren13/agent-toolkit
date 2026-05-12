module DiffCoverage
  module_function

  # hits: { file => [nil|0|N, ...] }   (SimpleCov per-line hit array, 1-indexed via [n - 1])
  # diff: { file => [line_numbers] }
  def report(hits, diff)
    diff.each_with_object({}) do |(file, lines), out|
      file_hits = hits[file] || []
      executable = lines.select { |n| !file_hits[n - 1].nil? }
      covered = executable.count { |n| file_hits[n - 1].to_i.positive? }
      total = executable.size
      percent = total.zero? ? 100.0 : (covered.to_f / total * 100).round(1)
      out[file] = { covered: covered, total: total, percent: percent }
    end
  end

  # Parse `git diff --unified=0 <base>...HEAD` output.
  # Returns: { file => [line_numbers_added_or_modified] }
  def parse_diff_lines(diff_output)
    result = {}
    current_file = nil
    diff_output.each_line do |line|
      if line =~ %r{^diff --git a/(.+) b/(.+)$}
        current_file = Regexp.last_match(2)
        result[current_file] ||= []
      elsif line =~ /^@@ -\d+(?:,\d+)? \+(\d+)(?:,(\d+))? @@/
        start = Regexp.last_match(1).to_i
        count = (Regexp.last_match(2) || '1').to_i
        next if count.zero?

        result[current_file].concat((start...(start + count)).to_a)
      end
    end
    result
  end
end
