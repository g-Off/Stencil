class ImportNode: NodeType {
  let templateName: Variable
  
  class func parse(_ parser: TokenParser, token: Token) throws -> NodeType {
    let components = token.components()
    guard components.count == 2 else {
      throw TemplateSyntaxError("'import' tag takes one argument, the template file to be imported")
    }
    let templateName = Variable(components[1])
    
    return ImportNode(templateName: templateName)
  }
  
  init(templateName: Variable) {
    self.templateName = templateName
  }
  
  func render(_ context: Context) throws -> String {
    guard let templateName = try self.templateName.resolve(context) as? String else {
      throw TemplateSyntaxError("'\(self.templateName)' could not be resolved as a string")
    }
    
    let template = try context.environment.loadTemplate(name: templateName)
    _ = try template.render(context)
    return ""
  }
}
