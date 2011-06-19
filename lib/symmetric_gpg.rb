# A gpg command line wrapper for symmetric encryption
module SymmetricGPG
  VERSION = '1.2.0'

  CRYPTOR = 'gpg -q --batch --passphrase-fd 0'
  ENCRYPTING = '--force-mdc --symmetric'
  DECRYPTING = '--decrypt'

  # Data is to be subclassed.
  # It just defines the attributes.
  class Data
    attr_accessor :passphrase, :plain, :encrypted, :force
    attr_accessor :cryptor, :encrypting, :decrypting

    def initialize(passphrase=nil,plain=nil,encrypted=nil,force=true)
      @passphrase, @plain, @encrypted, @force = passphrase, plain, encrypted, force
      @cryptor, @encrypting, @decrypting = CRYPTOR, ENCRYPTING, DECRYPTING
    end

    # in version 1.1.0, all attributes where checked, but
    # really just need to ensure implimentation set these three.
    def nils?
      [@passphrase, @plain, @encrypted].each do |attribute|
        return true if attribute.nil?
      end
      return false
    end

    def nils!
      raise "missing attribute" if nils?
    end
  end

  autoload :Files,	'symmetric_gpg/files'
  autoload :IOs,	'symmetric_gpg/ios'
  autoload :Strings,	'symmetric_gpg/strings'
end
