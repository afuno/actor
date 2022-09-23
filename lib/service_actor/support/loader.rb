# frozen_string_literal: true

require "zeitwerk"

lib = File.expand_path("../..", __dir__)

puts
puts
puts :lib
puts lib.inspect
puts
puts

loader = Zeitwerk::Loader.new
loader.tag = "service_actor"
loader.inflector = Zeitwerk::GemInflector.new(
  File.expand_path("service_actor.rb", lib),
)
loader.push_dir(lib)
loader.ignore(__dir__)
loader.setup

module ServiceActor; end
