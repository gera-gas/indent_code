require 'optparse'
require 'fileutils'
require 'indent_code/application'
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
  
end # module IndentCode
