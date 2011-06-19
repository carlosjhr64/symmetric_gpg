module SymmetricGPG
# IOs encrypts/decrypts io streams
class IOs < Data

  def initialize(*parameters)
    super
  end

  def self.in_and_out(ioin,stdin,stdout,ioout)
    error = nil
    thread = Thread.new do
      begin
        while byte = ioin.getbyte do
          stdin.putc byte
        end
      rescue Exception
        error = $!
      ensure
        stdin.close_write
      end
    end
    while char = stdout.getbyte do
      ioout.putc char
    end
    thread.join
    raise error if error
  end

  def cryptor_io_pipe(type)
    ioin,ioout = (type != @encrypting)? [@encrypted,@plain] : [@plain,@encrypted]
    Open3.popen3( "#{CRYPTOR} #{type}") do |stdin,stdout,stderr|
      stdin.puts @passphrase
      IOs.in_and_out(ioin,stdin,stdout,ioout)
      read_errors(stderr)
    end
  end

  def encrypt
    nils!
    cryptor_io_pipe(@encrypting)
    @errors.nil?
  end

  def decrypt
    nils!
    cryptor_io_pipe(@decrypting)
    @errors.nil?
  end

end
end
