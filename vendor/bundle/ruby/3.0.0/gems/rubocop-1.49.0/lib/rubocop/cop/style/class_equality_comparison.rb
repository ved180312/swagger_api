# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # Enforces the use of `Object#instance_of?` instead of class comparison
      # for equality.
      # `==`, `equal?`, and `eql?` methods are allowed by default.
      # These are customizable with `AllowedMethods` option.
      #
      # @example
      #   # bad
      #   var.class == Date
      #   var.class.equal?(Date)
      #   var.class.eql?(Date)
      #   var.class.name == 'Date'
      #
      #   # good
      #   var.instance_of?(Date)
      #
      # @example AllowedMethods: [] (default)
      #   # good
      #   var.instance_of?(Date)
      #
      #   # bad
      #   var.class == Date
      #   var.class.equal?(Date)
      #   var.class.eql?(Date)
      #   var.class.name == 'Date'
      #   var.class.to_s == 'Date'
      #   var.class.inspect == 'Date'
      #
      # @example AllowedMethods: [`==`]
      #   # good
      #   var.instance_of?(Date)
      #   var.class == Date
      #   var.class.name == 'Date'
      #   var.class.to_s == 'Date'
      #   var.class.inspect == 'Date'
      #
      #   # bad
      #   var.class.equal?(Date)
      #   var.class.eql?(Date)
      #
      # @example AllowedPatterns: [] (default)
      #   # good
      #   var.instance_of?(Date)
      #
      #   # bad
      #   var.class == Date
      #   var.class.equal?(Date)
      #   var.class.eql?(Date)
      #   var.class.name == 'Date'
      #   var.class.to_s == 'Date'
      #   var.class.inspect == 'Date'
      #
      # @example AllowedPatterns: ['eq']
      #   # good
      #   var.instance_of?(Date)
      #   var.class.equal?(Date)
      #   var.class.eql?(Date)
      #
      #   # bad
      #   var.class == Date
      #   var.class.name == 'Date'
      #   var.class.to_s == 'Date'
      #   var.class.inspect == 'Date'
      #
      class ClassEqualityComparison < Base
        include RangeHelp
        include AllowedMethods
        include AllowedPattern
        extend AutoCorrector

        MSG = 'Use `instance_of?(%<class_name>s)` instead of comparing classes.'

        RESTRICT_ON_SEND = %i[== equal? eql?].freeze
        CLASS_NAME_METHODS = %i[name to_s inspect].freeze

        # @!method class_comparison_candidate?(node)
        def_node_matcher :class_comparison_candidate?, <<~PATTERN
          (send
            {$(send _ :class) (send $(send _ :class) #class_name_method?)}
            {:== :equal? :eql?} $_)
        PATTERN

        def on_send(node)
          def_node = node.each_ancestor(:def, :defs).first
          return if def_node &&
                    (allowed_method?(def_node.method_name) ||
                    matches_allowed_pattern?(def_node.method_name))

          class_comparison_candidate?(node) do |receiver_node, class_node|
            range = offense_range(receiver_node, node)
            class_name = class_name(class_node, node)

            add_offense(range, message: format(MSG, class_name: class_name)) do |corrector|
              corrector.replace(range, "instance_of?(#{class_name})")
            end
          end
        end

        private

        def class_name(class_node, node)
          if class_name_method?(node.children.first.method_name)
            return class_node.receiver.source if class_node.receiver

            if class_node.str_type?
              value = class_node.source.delete('"').delete("'")
              value.prepend('::') if class_node.each_ancestor(:class, :module).any?
              return value
            end
          end

          class_node.source
        end

        def class_name_method?(method_name)
          CLASS_NAME_METHODS.include?(method_name)
        end

        def offense_range(receiver_node, node)
          range_between(receiver_node.loc.selector.begin_pos, node.source_range.end_pos)
        end
      end
    end
  end
end
