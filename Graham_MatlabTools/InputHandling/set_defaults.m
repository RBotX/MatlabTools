%DESCRIPTION: This function takes a structure of default values and sets
%any undeclared properties in a settings structure to equal those defaults,
%while leaving declared properties in place.
%*MOSTLY USEFUL AS AN ALTERNATIVE TO VARAGIN FOR SETTINGS ARGUMENT DEFAULTS

%INPUT: 
%---------------------------------------------------------------
% settings: structure with properties declared by a user
%---------------------------------------------------------------
% defaults: structure with properties that will be copied over to settings
% if they weren't already declared

%OUTPUT:
%---------------------------------------------------------------
% settings: updated structure with both user defined and default properties
function settings = set_defaults(settings,defaults)

    allFields = fieldnames(defaults);
    providedFields = fieldnames(settings);
    unsetFields = allFields(~ismember(allFields,providedFields));

    %Set all fields from defaults that were not defined in settings
    function dynamicFieldSet(field)
        settings.(field) = defaults.(field);
    end
    cellfun(@(field) dynamicFieldSet(field), unsetFields);
end

