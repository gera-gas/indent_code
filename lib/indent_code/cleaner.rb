require 'iparser'

module IndentCode

  class Cleaner
    include IndentCode

    def initialize
      @parser = Iparser::Machine.new

      @st_idle    = Iparser::State.new('idle')
      @st_cline   = Iparser::State.new('comment-line')
      @st_cblock  = Iparser::State.new('comment-block')
      @st_string  = Iparser::State.new('string')
      @st_screen  = Iparser::State.new('screen')
      @st_cleaner = Iparser::State.new('cleaner')
      @st_cpp     = Iparser::State.new('cpp')

      @parser.addstate @st_idle
      @parser.addstate @st_cleaner
      @parser.addstate @st_cline
      @parser.addstate @st_cblock
      @parser.addstate @st_string
      @parser.addstate @st_screen
      @parser.addstate @st_cpp
      
      # Setting idle state.
      @st_idle.ignore[:all] << ' '
      @st_idle.branches << @parser.state_index( @st_cleaner )
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
      @st_cpp.leave << '#'
      @st_cpp.leave << 'e'
      @st_cpp.leave << 'n'
      @st_cpp.leave << 'd'
      @st_cpp.leave << 'i'
      @st_cpp.leave << 'f'
      @st_cpp.ignore[:all] << ' '
      @st_cpp.branches << @parser.state_index( @st_cpp )

      # Setting cleaner handler state.
      @st_cleaner.entry << '#'
      @st_cleaner.entry << 'i'
      @st_cleaner.entry << 'f'
      @st_cleaner.entry << '0'
      @st_cleaner.leave << '#'
      @st_cleaner.leave << 'e'
      @st_cleaner.leave << 'n'
      @st_cleaner.leave << 'd'
      @st_cleaner.leave << 'i'
      @st_cleaner.leave << 'f'
      @st_cleaner.ignore[:all] << ' '
      @st_cleaner.branches << @parser.state_index( @st_cpp )
      @st_cleaner.branches << @parser.state_index( @st_cline )
      @st_cleaner.branches << @parser.state_index( @st_cblock )
      @st_cleaner.branches << @parser.state_index( @st_string )
      
      @st_cleaner.init( method( :cleaner_init ) )
      @st_cleaner.fini( method( :cleaner_fini ) )

      @parser.prestart
    end
    
    def cleaner_init ( ary )
      @@context[:indent] = 'lock'; return nil
    end
    
    def cleaner_fini ( ary )
      @@context[:indent] = 'unlock'; return nil
    end
    
    private :cleaner_init, :cleaner_fini

    # clean method handler.
    def clean ( c )
      return @parser.parse( c )
    end

  end # class Cleaner

end # module IndentCode
