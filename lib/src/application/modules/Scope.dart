/*
 * Copyright (c) 2015, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 * 
 * All Rights Reserved.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

part of mdlapplication;

Object mdlRootContext() {
    final Logger _logger = new Logger('mdlapplication.mdlRootContext');

    Object rootContext;
    try {
        rootContext = componentFactory().injector.get(MaterialApplication);
    }
    on Error catch(e,stack) {
        _logger.shout(e,stack);

        throw new ArgumentError("Could not find rootContext.\n"
        "Please define something like this: \n"
        "class Applicaiton extends MaterialApplication { ... } \n"
        "componentFactory().rootContext(Application).run().then((_) { ... }");
    }
    return rootContext;
}

/// Looks for a SCOPE-AWARE!!!-Parent
Scope mdlParentScope(final MdlComponent component) {
  final Logger _logger = new Logger('mdlapplication.mdlParentScope');

  if(component.parent == null) {
      _logger.fine("$component has no parent!");
    return null;
  }
  if(component.parent is ScopeAware) {

    return (component.parent as ScopeAware).scope;

  } else {
        _logger.fine("${component.parent} (ID: ${component.parent.element.id}) is a MdlComponent but not ScopeAware!");
  }
  return mdlParentScope(component.parent);
}

/**
 * Usage:
 *  final Scope scope = new Scope(this, mdlParentScope(this));
 */
class Scope {
    final Logger _logger = new Logger('mdlapplication.Scope');

    final Scope _parentScope;

    Object _context;
    Object _rootContext;

    /// [_parentScope] can be null if there is no parent
    Scope(this._context,this._parentScope);

    Object get context => _context;
    void set context(final Object cntxt) {
      _context = cntxt;
    }

    /// Returns the next SCOPE-AWARE-Parent ( Component that implements ScopeAware )
    Object get parentContext {
        if(_parentScope != null) {
            return _parentScope.context;
        }
        return rootContext;
    }

    Object get rootContext {
        if(_rootContext == null) {
            _rootContext = mdlRootContext();
        }
        return _rootContext;
    }

    //- private -----------------------------------------------------------------------------------
}

@di.Injectable()
class RootScope extends Scope {
    RootScope() : super(mdlRootContext(),null);
}