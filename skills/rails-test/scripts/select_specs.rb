#!/usr/bin/env ruby
# Spec-selection script — invoked by /rails-test-run.
# Prints selected spec paths to stdout, one per line.
# Prints a "Selection: …" reason line to stderr.
$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'spec_selector'

base = ARGV[0] || 'testing'

# 1. Failures-first
examples_file = 'spec/examples.txt'
if File.exist?(examples_file)
  failed = File.readlines(examples_file).select { |l| l =~ /\| failed\b/ }
  unless failed.empty?
    warn "Selection: failures-first (#{failed.size} failures from spec/examples.txt)"
    failed.each { |l| puts l.split(' | ').first.strip }
    exit 0
  end
end

# 2. Diff-based
changed = `git diff #{base}...HEAD --name-only`
            .lines
            .map(&:strip)
            .select { |p| p.start_with?('app/') && p.end_with?('.rb') }

if changed.empty?
  warn 'Selection: no failures, no app changes — use /rails-test-full to run everything'
  exit 0
end

specs = SpecSelector.select(changed_app_files: changed)
if specs.empty?
  warn "Selection: #{changed.size} app files changed but no matching specs found — use /rails-test-full"
  exit 0
end

warn "Selection: diff-based (#{specs.size} specs from #{changed.size} changed files vs #{base})"
specs.each { |s| puts s }
