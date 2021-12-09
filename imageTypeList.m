classdef imageTypeList

    properties
        fullNames
        shortNames
        values
    end

    methods

        function obj = imageTypeList()
            obj.fullNames = {'power Doppler', 'Power 1 Doppler', 'Power 2 Doppler', 'color Doppler', 'directional Doppler', 'M0sM1r', 'velocity estimate'};
            obj.shortNames = ['power', 'color', 'directional', 'velocity'];
        end

        function obj = chooseImageType (obj,boolean_type_list)
            obj.values = boolean_type_list;
        end

    end
end
