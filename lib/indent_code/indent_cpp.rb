require 'iparser'

module IndentCode

  class IndentCPP
    include IndentCode

    def initialize
      @parser = Iparser::Machine.new

      @st_cline  = Iparser::State.new('comment-line')
      @st_cblock = Iparser::State.new('comment-block')
      @st_char   = Iparser::State.new('char')
      @st_string = Iparser::State.new('string')
      @st_screen = Iparser::State.new('screen')
      @st_scope  = Iparser::State.new('scope')

      @parser.addstate @st_scope
      @parser.addstate @st_cline
      @parser.addstate @st_cblock
      @parser.addstate @st_char
      @parser.addstate @st_string
      @parser.addstate @st_screen

      # Setting comment-line state.
      @st_cline.entry << '/'
      @st_cline.entry << '/'
      @st_cline.leave << /[\n\r]/

      # Setting comment-block state.
      @st_cblock.entry << '/'
      @st_cblock.entry << '*'
      @st_cblock.leave << '*'
      @st_cblock.leave << '/'
      
      @st_cblock.handler( method( :cblock_handler ) )
      @st_cblock.fini( method( :cblock_fini ) )

      # Setting char state.
      @st_char.entry << "'"
      @st_char.leave << "'"
      @st_char.branches << @parser.state_index( @st_screen )

      # Setting string state.
      @st_string.entry << '"'
      @st_string.leave << '"'
      @st_string.branches << @parser.state_index( @st_screen )

      # Setting screen state.
      @st_screen.entry << '\\'
      @st_screen.leave << /./

      # Setting open state.
      @st_scope.entry << '{'
      @st_scope.leave << '}'
      @st_scope.branches << @parser.state_index( @st_scope )
      @st_scope.branches << @parser.state_index( @st_cline )
      @st_scope.branches << @parser.state_index( @st_cblock )
      @st_scope.branches << @parser.state_index( @st_string )
      @st_scope.branches << @parser.state_index( @st_char )

      @st_scope.init( method( :scope_init ) )
      @st_scope.fini( method( :scope_fini ) )
      
      @parser.prestart
    end

    def cblock_handler ( c )
      if c == ?\n then
        if( (@@context[:linetxt].length > 0) && (@@context[:linetxt][0] == ?*) ) then
          @@context[:linetxt] = ' ' + @@context[:linetxt]
        end
      end
      return nil
    end

    def cblock_fini ( str )
      @@context[:linetxt] = ' ' + @@context[:linetxt]
      return nil
    end

    def scope_init ( str )
      @@context[:indent] += @@options[:tab]
      return nil
    end

    def scope_fini ( str )
      if @@context[:indent] < @@options[:tab] then
        @@context[:message] = 'Extra closing brace or missing a left brace'
        return 'break'
      end
      @@context[:indent] -= @@options[:tab]
      return nil
    end

    private :cblock_handler, :cblock_fini, :scope_init, :scope_fini

    # indent method for this language.
    def indent ( c )
      return @parser.parse( c )
    end

  end # class IndentCPP

end # module IndentCode
