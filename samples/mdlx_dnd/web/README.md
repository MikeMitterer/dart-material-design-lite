###Remark
In the DND sample you can see the following HTML-Structure:

```html
    <div class="danddcontainer">
        <div class="choose ">
                <mdl-repeat class="source langbox mdl-dnd__drag-container" 
                    for-each="language in languages">
                    ...
                </mdl-repeat>
        </div>
        <div class="accept">
            <div class="langbox">
                <mdl-dropzone class="natural" name="natural"
                              on-drop-success="addToNaturalLanguages(data)">

                    <mdl-repeat for-each="language in natural" class="mdl-dnd__drag-container">
                        ...
                    </mdl-repeat>
                </mdl-dropzone>
            </div>
        </div>
    </div>

```

The first mdl-repeat takes 'languages' from your Application - there is no surrounding component.  
The second mdl-repeat is encapsulated in mdl-dropzone. You could assume that it takes natural from mdl-dropzone
(its surrounding component) - you are right with most components. No so with mdl-dropzone.  
 
mdl-dropzone (its class MaterialDropZone) is not ScopeAware. Because of this mdl-repeat looks for the
next ScopeAware parent, can't find one and takes your Application as RootContext.