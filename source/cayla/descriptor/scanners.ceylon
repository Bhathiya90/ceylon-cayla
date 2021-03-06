import ceylon.language.meta { type }
import ceylon.language.meta.model { ClassModel }
import ceylon.language.meta.declaration { ClassDeclaration, Package, ValueDeclaration, NestableDeclaration }
import cayla { Controller }

shared ControllerDescriptor[] scanControllersInPackage(Package pkg) {
	value memberDecls = pkg.members<NestableDeclaration>();
	ControllerDescriptor[] controllers1 = [*{
		for (memberDecl in memberDecls)
			if (is ValueDeclaration memberDecl, exists member = memberDecl.get())
				for (controller in scanControllersInObject(member))
					controller
	}];
	ControllerDescriptor[] controllers2 = [*{
		for (memberDecl in memberDecls)
			if (is ClassDeclaration memberDecl, exists x = memberDecl.extendedType, x.declaration.equals(`class Controller`))
				ControllerDescriptor(factory(memberDecl), memberDecl)
	}];
	return concatenate(controllers1, controllers2);
}

Anything factory(ClassDeclaration classDecl)(Anything[] arguments) {
	return classDecl.instantiate {
		arguments = arguments;
	};
}
Anything memberFactory(ClassDeclaration classDecl, Object o)(Anything[] arguments) {
	return classDecl.memberInstantiate {
		container = o;
		arguments = arguments;
	};
}

shared ControllerDescriptor[] scanControllersInObject(Object obj) {
	ClassModel<Object> classModel = type(obj);
	value memberDecls = classModel.declaration.memberDeclarations<ClassDeclaration>();	
	ControllerDescriptor[] controllers = [*{
		for (memberDecl in memberDecls)
			if (exists x = memberDecl.extendedType, x.declaration.equals(`class Controller`))
				ControllerDescriptor(memberFactory(memberDecl, obj), memberDecl)		
		}];
	return controllers;
}

