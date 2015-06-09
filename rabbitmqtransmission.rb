require 'rubygems'
require 'bunny'


class RabbitMQTransmission
  def initialize()
    @chanelRabbit = 0
  end
  
  def SendMessage(message,name_queue)
    
    #connectionRabbit()
    #selection queue
    #queue = @chanelRabbit.queue(name_queue)
    
    queue = getQueue(name_queue)
    #publish message
    queue.publish(message);
    #close connection
    closeRabbit()
    
    true    
  end 

  def ReciveMessage(name_queue)
    #connection to instanse RabbitMQ
#    connectionRabbit()
    #check queue
#   queue = @chanelRabbit.queue(name_queue)
    
    queue = getQueue(name_queue)
    #initialization data massive
    data = Array.new 
    
    queue.subscribe(:block => true) do |delivery_info, properties, body|   
      data << "#{body}" 
    end
       
    #close connection to instanse RabbitMQ
    closeRabbit()

    data
  end
  
protected 
  
  def getQueue(name)
    #connection to instanse RabbitMQ
    connectionRabbit()
    #check queue
    queue = @chanelRabbit.queue(name)
    return queue
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

