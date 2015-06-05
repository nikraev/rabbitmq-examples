require 'rubygems'
require 'bunny'


class RabbitMQTransmission
  def initialize()
    
  end
  
  def SendMessage(message,name_queue)
    
    connectionRabbit()
    #selection queue
    queue = @chanelRabbit.queue(name_queue)
    #publish message
    queue.publish(message);
    #close connection
    closeRabbit()
    
    true    
  end 

  def ReciveMessage(name_queue)
    #connection to instanse RabbitMQ
    connectionRabbit()
    #check queue
    queue = @chanelRabbit.queue(name_queue)
    
    #initialization data massive
    data = Array.new 
    
    queue.subscribe(:block => true) do |delivery_info, properties, body|   
      data << "#{body}" 
    end
       
    #close connection to instanse RabbitMQ
    closeRabbit()

    data
  end
  
private 
  def connectionRabbit()
    
    #establishing connection
    @connRabbit = Bunny.new
    @connRabbit.start
    #create chanal
    @chanelRabbit = @connRabbit.create_channel
    
  end
  
  def closeRabbit()
    @connRabbit.close
  end
end 

mass = Array.new
mass << 1
mass << 2
mass << 3
mass << 4


rabbit = RabbitMQTransmission.new
puts "Message is send\n" if rabbit.SendMessage(mass,"data")

values = Array.new
values = rabbit.ReciveMessage("data")

values.each do |element|
  puts element.to_s  
  
end
    
#data.each do |element|
#      puts "#{element}"
#end

