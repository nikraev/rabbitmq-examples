require 'rubygems'
require 'bunny'
require_relative 'rabbitmqtransmission.rb'

class WorkQueuesRabbit < RabbitMQTransmission
  
  def ReciveMessage(name_queue)
    
    queue = getQueue(name_queue)
    queue.subscribe(:manual_ack => true, :block => true) do |delivery_info, properties, body|
      puts " [x] Received #{body}"
      
      30.times do |i|
        sleep 1
        puts "#{i+1} seconds"
        puts "Delivery time"  
      end
      
      sendAck(delivery_info)
      puts "Delivery complite"
    end  
    closeRabbit()      
    
  end
  
  def SendMessage(message,name_queue)
      queue = getQueue(name_queue)
      queue.publish(message, :persistent => true)
      closeRabbit()      
      true
  end
  
private 
    def sendAck(delivery_info)
      @chanelRabbit.ack(delivery_info.delivery_tag)
    end
end 


wqueue = WorkQueuesRabbit.new

wqueue.SendMessage("mail agent","workdata")
wqueue.ReciveMessage("workdata")
