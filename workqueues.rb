require 'rubygems'
require 'bunny'
require_relative 'rabbitmqtransmission.rb'

class WorkQueuesRabbit < RabbitMQTransmission
  
  def ReciveMessage(name_queue)
    
    queue = getQueue(name_queue)
    queue.subscribe(:manual_ack => true, :block => true) do |delivery_info, properties, body|
      puts " [x] Received #{body}"
      sleep body.count(".").to_i
      puts " [x] Done"
      @chanelRabbit.ack(delivery_info.delivery_tag)
    end  
  end
  
  def SendMessage(message,name_queue)
      queue = getQueue(name_queue)
      queue.publish(message, :persistent => true)
      closeRabbit()      
      true
  end
  
end 


wqueue = WorkQueuesRabbit.new

wqueue.SendMessage("hello","workdata")
wqueue.ReciveMessage("workdata")
