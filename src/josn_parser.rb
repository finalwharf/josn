#!/usr/bin/env ruby

require_relative 'simple_queue'

# Josn - poor men's broken JSON parser
class Josn
  attr_accessor :json_queue

  private_class_method :new

  class << self
    def dump(hash)
      hash.to_s
    end

    def parse(string)
      josn = new(string)
      josn.json_value
    end
  end


  def initialize(json_string)
    self.json_queue = SimpleQueue.new

    json_string.chars.each do |char|
      self.json_queue.add(char)
    end
  end

  # Parse a JSON value of unknown type
  def json_value
    while !json_queue.empty?
      token = json_queue.peek
      if token == '{'
        return parse_object
      elsif token == '['
        return parse_array
      elsif token == '"'
        return parse_string
      elsif token == ' '
        json_queue.poll
      else
        return parse_unquoted
      end
    end
  end


  # Parse JSON arrays
  def parse_array
    array = []

    # Remove leading bracket
    json_queue.poll

    # Empty array
    if json_queue.peek == ']'
      json_queue.poll
      return []
    end

    while !json_queue.empty?
      array.push(json_value)
      break if json_queue.poll != ','
    end

    array
  end


  # Parse JSON objects
  def parse_object
    object = {}

    # Remove leading curly brace
    json_queue.poll

    # Empty hash
    if json_queue.peek == '}'
      json_queue.poll
      return {}
    end

    while !json_queue.empty?
      # Parse a quoted sting or a generic unquoted value
      key = if json_queue.peek == '"'
        parse_string
      else
        parse_unquoted(for_key: true)
      end.to_s

      json_queue.poll # remove colon
      object[key] = json_value

      break if json_queue.poll != ','
    end

    object
  end


  # Parse quoted JSON strings
  def parse_string
    string = ''

    # Remove leading quote
    json_queue.poll
    while !json_queue.empty?
      char = json_queue.poll
      string << char if char != '\\' || json_queue.peek != '"'
      break if json_queue.peek == '"' && char != '\\'
    end

    # Remove trailing quote
    json_queue.poll
    string.strip
  end


  # Parse unquoted JSON values
  # Subsequently cast to a specific type
  def parse_unquoted(for_key: false)
    string = ''
    break_tokens = '{}[],'.chars

    # Only care about a colon (:) if we are parsing a key
    break_tokens << ':' if for_key

    while !json_queue.empty?
      string << json_queue.poll
      break if break_tokens.include?(json_queue.peek)
    end
    cast(string.strip)
  end


  # Cast a string value to a more appropriate type
  # Support for reserved words, integers, floats, and... strings
  def cast(string)
    reserved_words = {
      'true'  => true,
      'false' => false,
      'null'  => nil
    }

    if string =~ /\A(true|false|null)\z/
      reserved_words[string]
    elsif string =~ /\A-?\d+\z/
      string.to_i
    elsif string =~ /\A-?(\d+)?\.\d+\z/
      string.to_f
    else
      string
    end
  end
end
