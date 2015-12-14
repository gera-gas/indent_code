require 'iparser'

module IndentCode

  class Cleaner
    include IndentCode

    def initialize
      @parser = Iparser::Machine.new

      @st_idle   = Iparser::State.new('idle')
      @st_cline  = Iparser::State.new('comment-line')
      @st_cblock = Iparser::State.new('comment-block')
      @st_string = Iparser::State.new('string')
      @st_screen = Iparser::State.new('screen')
      @st_cpp    = Iparser::State.new('cpp')

      @parser.addstate @st_idle
      @parser.addstate @st_cpp
      @parser.addstate @st_cline
      @parser.addstate @st_cblock
      @parser.addstate @st_string
      @parser.addstate @st_screen
      
      # Setting idle state.
      @st_idle.ignore[:all] << ' '
      @st_idle.branches << @parser.state_index( @st_cpp )
      @st_idle.branches << @parser.state_index( @st_cline )
      @st_idle.branches << @parser.state_index( @st_cblock )
      @st_idle.branches << @parser.state_index( @st_string )

      # Setting comment-line state.
      @st_cline.entry << '/'
      @st_cline.entry << '/'
      @st_cline.leave << /[\n\r]/

      # Setting comment-block state.
      @st_cblock.entry << '/'
      @st_cblock.entry << '*'
      @st_cblock.leave << '*'
      @st_cblock.leave << '/'

      # Setting string state.
      @st_string.entry << '"'
      @st_string.leave << '"'
      @st_string.branches << @parser.state_index( @st_screen )

      # Setting screen state.
      @st_screen.entry << '\\'
      @st_screen.leave << /./

      # Setting preprocessor handler state.
      @st_cpp.entry << '#'
      @st_cpp.entry << 'i'
      @st_cpp.entry << 'f'
      @st_cpp.entry << '0'
      @st_cpp.leave << '#'
      @st_cpp.leave << 'e'
      @st_cpp.leave << 'n'
      @st_cpp.leave << 'd'
      @st_cpp.leave << 'i'
      @st_cpp.leave << 'f'
      @st_cpp.ignore[:all] << ' '
      @st_cpp.branches << @parser.state_index( @st_cline )
      @st_cpp.branches << @parser.state_index( @st_cblock )
      @st_cpp.branches << @parser.state_index( @st_string )
      
      @st_cpp.init( method( :cpp_init ) )
      @st_cpp.fini( method( :cpp_fini ) )

      @parser.prestart
    end
    
    def cpp_init ( ary )
      @@context[:indent] = 'lock'; return nil
    end
    
    def cpp_fini ( ary )
      @@context[:indent] = 'unlock'; return nil
    end
    
    private :cpp_init, :cpp_fini

    # clean method handler.
    def clean ( c )
      return @parser.parse( c )
    end

  end # class Cleaner

end # module IndentCode
