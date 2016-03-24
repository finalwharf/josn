# A simple implementation of a queue
class SimpleQueue
  # Creates a new queue with some starting elements or an empty one if no arguments are passed
  def initialize()
    @store = []
  end

  # Adds an element to the queue
  def add(element)
    @store.push(element)
  end

  # Retrieves and removes the head of the queue
  def poll
    @store.shift
  end

  # Retrieves and removes the head of the queue
  # Raises an exception if the queue is empty
  def remove
    raise_if_empty
    poll
  end

  # Returns the size of the queue
  def size
    @store.size
  end

  # Retrieves but does not remove the head of the queue
  def peek
    @store.first
  end

  # Retrieves but does not remove the head of the queue
  # Raises an exception if the queue is empty
  def element
    raise_if_empty
    peek
  end

  def display
    puts @store.join(' ')
  end

  def empty?
    @store.empty?
  end

  def empty!
    @store = []
  end

  def to_a
    @store.clone
  end

  def raise_if_empty
    raise EmptyQueueError if @store.empty?
  end
end

class EmptyQueueError < StandardError
  def message
    'Queue is empty'
  end
end
