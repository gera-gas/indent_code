require 'optparse'
require 'fileutils'
require 'indent_code/indent_cpp'
require 'indent_code/cleaner'
require 'indent_code/version'

module IndentCode

  # command line options.
  @@options = {
    :tab => 4,
    :lang => 'cpp',
    :style => '',
    :clean => false,
    :delete => false,
  }

  # indent parse context.
  @@context = {
    :indent => 0,
    :linenum => 1,
    :linetxt => '',
    :message => '',
  }

  # file descriptors.
  @@files = { :fin => nil, :fout => nil, }

  # error handler, display error message.
  def self.error ( m = '' )
    if m == '' then
      puts "ERROR : #{@@context[:message]}."
      puts "LINE  : #{@@context[:linenum]}"
      puts "TEXT  : #{@@context[:linetxt]}"
    else
      puts "ERROR : #{m}."
    end
    exit
  end

  # Class for application control methods.
  class Application
    include IndentCode

    def initialize
      # parse command line options.
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: indent file [options]"

        opts.on('-i', '--indent size', 'Set indent size (TAB size): --indent 4') do |size|
          @@options[:tab] = size.to_i;
        end
        opts.on('-c', '--clean', 'Delete code blocks from source code is framed as: #if 0 ... #endif') do
          @@options[:clean] = true;
        end
	opts.on('-d', '--delete', 'Delete temporary files after work (*~ and *~~)') do
          @@options[:delete] = true;
        end
        opts.on('-h', '--help', 'Displays Help') do
          puts opts
          exit
        end
      end
      parser.parse!

      # check command line arguments.
      if ARGV.size == 0 then
        IndentCode.error 'no input file, run with option -h or --help'
      end
      if !File.file?( ARGV[0] ) then
        IndentCode.error 'unable to open file ' + ARGV[0]
      end
      exit if File.size( ARGV[0] ) == 0
    end

    # start indent handling.
    def run
      # create source file copy for backup.
      FileUtils.copy( ARGV[0], ARGV[0] + ?~ )

      parser = nil
      # create indent parser.
      case @@options[:lang]
      when 'cpp'
        parser = IndentCPP.new          
      end

      f = File.new( ARGV[0], 'w' )
      # parse input file.
      File.open( ARGV[0] + ?~, 'r' ).each do |line|
        @@context[:linetxt] = line.strip
        indent = @@context[:indent]

        # parse each char from string.
        line.each_char do |c|
          IndentCode.error() if !parser.indent( c )
        end

        indent = @@context[:indent] if @@context[:indent] < indent
        spaces = ' ' * indent

        f.puts spaces + @@context[:linetxt]
        @@context[:linenum] = @@context[:linenum] + 1
      end
      f.close

      # clean source code.
      if @@options[:clean] then
	# create source file copy for backup.
        FileUtils.copy( ARGV[0], ARGV[0] + '~~' )
	
	cleaner = IndentCode::Cleaner.new	
	@@context[:indent] = ''
	
	f = File.new( ARGV[0], 'w' )
	# parse input file.
	File.open( ARGV[0] + '~~', 'r' ).each do |line|
	  @@context[:linetxt] = line
	  
	  # parse each char from string.
	  line.each_char do |c|
	    IndentCode.error() if !cleaner.clean( c )
	  end
	  
	  # check result of paring.
	  case @@context[:indent]
	  when ''
	    f.print @@context[:linetxt]
	  when 'lock'
	  when 'unlock'
	    @@context[:indent] = ''
	  end
	  
	  @@context[:linenum] = @@context[:linenum] + 1
	end
	f.close
      end
      
      # delete temporary files.
      if @@options[:delete] then
	FileUtils.remove( ARGV[0] + '~' )
	FileUtils.remove( ARGV[0] + '~~' )
      end
    end
  end # class Application
  
end # module IndentCode
