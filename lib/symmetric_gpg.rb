# A gpg command line wrapper for symmetric encription
class SymmetricGPG

  CRYPTOR = 'gpg -q --batch --passphrase-fd 0'
  ENCRYPTING = '--force-mdc --symmetric'
  DECRYPTING = '--decrypt'

  def initialize(passphrase)
    @passphrase = passphrase
  end

  ###########
  ### IOS ###
  ###########

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

  def self.cryptor_io_pipe(type,passphrase,ioin,ioout)
    IO.popen( "#{CRYPTOR} #{type}", 'w+' ){|pipe|
      pipe.puts passphrase
      SymmetricGPG.in_and_out(ioin,pipe,ioout)
    }
  end

  def p2ep(plain,encrypted)
    SymmetricGPG.cryptor_io_pipe(ENCRYPTING,@passphrase,plain,encrypted)
  end

  def e2pp(encrypted,plain)
    SymmetricGPG.cryptor_io_pipe(DECRYPTING,@passphrase,encrypted,plain)
  end

  ###############
  ### STRINGS ###
  ###############

  def self.write_read(instring,pipe)
    Thread.new{ pipe.write instring; pipe.close_write }
    pipe.read
  end

  def self.cryptor_str_pipe(type,passphrase,instring)
    outstring = nil
    IO.popen( "#{CRYPTOR} #{type}", 'w+' ){|pipe|
      pipe.puts passphrase
      outstring = SymmetricGPG.write_read(instring,pipe)
    }
    return outstring
  end

  def encstr(plain)
    SymmetricGPG.cryptor_str_pipe(ENCRYPTING,@passphrase,plain)
  end

  def decstr(encrypted)
    SymmetricGPG.cryptor_str_pipe(DECRYPTING,@passphrase,encrypted)
  end

  #############
  ### FILES ###
  #############

  def self.cryptor_files(infile,outfile,passphrase,force,type)
    yes = (force)? '--yes': ''
    IO.popen( "#{CRYPTOR} #{yes} --output '#{outfile}' #{type} '#{infile}'", 'w' ){|pipe|
      pipe.puts passphrase
      pipe.flush
    }
  end

  def encrypt( plain, encrypted, force=false )
    # validations
    raise "Plain file #{plain} does not exist" if !File.exist?(plain)
    raise "#{encrypted} exists" if !force && File.exist?(encrypted)

    # actions
    SymmetricGPG.cryptor_files(plain,encrypted,@passphrase,force,ENCRYPTING)

    # confirmation
    raise "Encripted #{encrypted} not created" if !File.exist?(encrypted)

    return encrypted
  end
  alias enc encrypt

  def decrypt( encrypted, plain, force=false)
    # validations
    raise "Encripted #{encrypted} does not exist" if !File.exist?(encrypted)
    raise "#{plain} exists" if !force && File.exist?(plain)

    # action
    SymmetricGPG.cryptor_files(encrypted,plain,@passphrase,force,DECRYPTING)

    # confirmation
    raise "Plain file #{plain} not created" if !File.exist?(plain)

    return plain
  end
  alias dec decrypt

end
