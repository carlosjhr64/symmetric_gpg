module SymmetricGPG
###########
### IOS ###
###########
class IOs

  def initialize(*parameters)
    super
  end

  def self.in_and_out(ioin,pipe,ioout)
    error = nil
    thread = Thread.new{
      begin
        while byte = ioin.getbyte do
          pipe.putc byte
        end
      rescue Exception
        error = $!
      ensure
        pipe.close_write
      end
    }
    while char = pipe.getbyte do
      ioout.putc char
    end
    thread.join
    raise error if error
  end

  def cryptor_io_pipe(type)
    ioin,ioout = (type != @encrypting)? [@encrypted,@plain] : [@plain,@encrypted]
    IO.popen( "#{CRYPTOR} #{type} 2> /dev/null", 'w+' ){|pipe|
      pipe.puts @passphrase
      IOs.in_and_out(ioin,pipe,ioout)
    }
  end

  def encrypt
    SymmetricGPG.cryptor_io_pipe(@encrypting)
  end

  def decrypt
    SymmetricGPG.cryptor_io_pipe(@decrypting)
  end

end
end
