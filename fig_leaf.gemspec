Gem::Specification.new do |s|
  s.name        = 'fig_leaf'
  s.version     = '0.0.3'
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.summary     = "Private inheritance for Ruby classes."
  s.description = "FigLeaf enables us to selectively make public methods inherited from other classes and modules private. The objects can still call these methods internally, but external classes are prevented from doing so."
  s.authors     = ["Avdi Grimm"]
  s.email       = ["sam@codeodor.com"]
  s.files       = ["lib/fig_leaf.rb"]
  s.homepage    = 'https://github.com/objects-on-rails/fig-leaf'
end