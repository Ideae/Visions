function [C,RC] = imfusecustom(A,RA,B,RB,method, maskA, maskB)
%IMFUSE Composite of two images.
%   C = IMFUSE(A,B) creates a composite image of two images A and B. If A
%   and B are different sizes, the smaller dimensions are padded with zeros
%   such that the two images are the same size before computing the
%   composite. The output, C, is a numeric matrix containing a fused
%   version of images A and B.
%
%   [C,RC] = IMFUSE(A,RA,B,RB) creates a fused image C from the images A
%   and B using the spatial referencing information provided in RA and RB.
%   RA, RB, and RC are spatial referencing objects of class imref2d. The
%   output RC defines the spatial referencing information for the output
%   fused image C.

%   Copyright 2011-2013 The MathWorks, Inc.

[A,B,A_mask,B_mask,RC] = calculateOverlayImages(A,RA,B,RB);
[maskA,maskB,~,~,RC] = calculateOverlayImages(maskA,RA,maskB,RB);
% compute final image for display
if strcmpi(method,'blend')
    C = local_createBlend;
elseif strcmpi(method,'max')
    C = local_createMax;
elseif strcmpi(method,'custom')
    C = local_createCustom;
end

%-------------------------------------
%--------- Nested Function -----------
%-------------------------------------

    function result = local_createBlend
        % Creates a transparent overlay image
        
        
        % compute regions of overlap
        onlyA = A_mask & ~B_mask;
        onlyB = ~A_mask & B_mask;
        bothAandB = A_mask & B_mask;
        
        % weight each image equally
        weight1 = 0.5;
        weight2 = 0.5;
        
        % allocate result image
        result = zeros([size(A,1) size(A,2) size(A,3)], class(A));
        
        % for each color band, compute blended output band
        for i = 1:size(A,3)
            a = A(:,:,i);
            b = B(:,:,i);
            r = result(:,:,i);
            r(onlyA) = a(onlyA);
            r(onlyB) = b(onlyB);
            r(bothAandB) = uint8( weight1 .* single(a(bothAandB)) + weight2 .* single(b(bothAandB)));
            result(:,:,i) = r;
        end
        
    end % local_createBlend


    function result = local_createMax
        % Creates a transparent overlay image
        
        
        % compute regions of overlap
        onlyA = A_mask & ~B_mask;
        onlyB = ~A_mask & B_mask;
        bothAandB = A_mask & B_mask;
        
        % weight each image equally
        weight1 = 0.5;
        weight2 = 0.5;
        
        % allocate result image
        result = zeros([size(A,1) size(A,2) size(A,3)], class(A));
        
        % for each color band, compute blended output band
        for i = 1:size(A,3)
            a = A(:,:,i);
            b = B(:,:,i);
            r = result(:,:,i);
            r(onlyA) = a(onlyA);
            r(onlyB) = b(onlyB);
            
%             g = fspecial('gaussian', [30,30]);
%             
%             onlyA = imfilter(onlyA, g);
%             onlyB = imfilter(onlyB, g);
            
            mida = single(a(bothAandB));
            midb = single(b(bothAandB));
            
            r(bothAandB) = max( mida , midb);
            result(:,:,i) = r;
        end
        
    end % local_createMax
function result = local_createCustom
        % Creates a transparent overlay image
        
        
        maskB = imfilter(maskB(:,:,1), fspecial('gauss', 30,15));
        maskA = imfilter(maskA(:,:,1), fspecial('gauss', 30,15));
        maskB = single(maskB >0.9);
        maskA = single(maskA >0.9);
        maskB = imfilter(maskB(:,:,1), fspecial('gauss', 30,15));
        maskA = imfilter(maskA(:,:,1), fspecial('gauss', 30,15));
        % compute regions of overlap
        onlyA = A_mask & ~B_mask;
        onlyB = ~A_mask & B_mask;
        bothAandB = A_mask & B_mask;
        
        % weight each image equally
        % allocate result image
        result = zeros([size(A,1) size(A,2) size(A,3)], class(A));
        temp = zeros([size(A,1) size(A,2) size(A,3)], class(A));
        % for each color band, compute blended output band
        for i = 1:size(A,3)
            a = A(:,:,i);
            b = B(:,:,i);
            mb = maskB(:,:,1);
            ma = maskA(:,:,1);
            r = result(:,:,i);
            t = temp(:,:,i);
            r(onlyA) = a(onlyA);
            r(onlyB) = b(onlyB);
            
%             g = fspecial('gaussian', [30,30]);
%             
%             onlyA = imfilter(onlyA, g);
%             onlyB = imfilter(onlyB, g);
            
            mida = single(a(bothAandB)).* ma(bothAandB);
            t(bothAandB) = mida;
            temp(:,:,i) = t;
            midb = single(b(bothAandB)).* mb(bothAandB);
            t(bothAandB) = midb;
            temp(:,:,i) = t;
%             maxmid = max(mida,midb);
            blendmid = (mida +  midb) ./ (mb(bothAandB)+ma(bothAandB));
            r(bothAandB) = blendmid;
            
            result(:,:,i) = r;
        end
        
    end % local_createCustom
end % imshowpair



function [A_padded,B_padded,A_mask,B_mask,R_output] = calculateOverlayImages(A,RA,B,RB)

% First calculate output referencing object. World limits are minimum
% bounding box that contains world limits of both images. Resolution is the
% minimum resolution in each dimension. We don't want to down sample either
% image.
outputWorldLimitsX = [min(RA.XWorldLimits(1),RB.XWorldLimits(1)),...
                      max(RA.XWorldLimits(2),RB.XWorldLimits(2))];
                  
outputWorldLimitsY = [min(RA.YWorldLimits(1),RB.YWorldLimits(1)),...
                      max(RA.YWorldLimits(2),RB.YWorldLimits(2))];                 
                  
goalResolutionX = min(RA.PixelExtentInWorldX,RB.PixelExtentInWorldX);
goalResolutionY = min(RA.PixelExtentInWorldY,RB.PixelExtentInWorldY);

widthOutputRaster  = ceil(diff(outputWorldLimitsX) / goalResolutionX);
heightOutputRaster = ceil(diff(outputWorldLimitsY) / goalResolutionY);

R_output = imref2d([heightOutputRaster, widthOutputRaster]);
R_output.XWorldLimits = outputWorldLimitsX;
R_output.YWorldLimits = outputWorldLimitsY;

fillVal = 0;
A_padded = images.spatialref.internal.resampleImageToNewSpatialRef(A,RA,R_output,'bilinear',fillVal);
B_padded = images.spatialref.internal.resampleImageToNewSpatialRef(B,RB,R_output,'bilinear',fillVal);

[outputIntrinsicX,outputIntrinsicY] = meshgrid(1:R_output.ImageSize(2),1:R_output.ImageSize(1));
[xWorldOverlayLoc,yWorldOverlayLoc] = intrinsicToWorld(R_output,outputIntrinsicX,outputIntrinsicY);
A_mask = contains(RA,xWorldOverlayLoc,yWorldOverlayLoc);
B_mask = contains(RB,xWorldOverlayLoc,yWorldOverlayLoc);

end



function [Aref,Bref,varargin] = preparseSpatialRefObjects(varargin)

spatialRefPositions   = cellfun(@(c) isa(c,'imref2d'), varargin);

Aref = [];
Bref = [];

if ~any(spatialRefPositions)
    return
end

if ~isequal(find(spatialRefPositions), [2 4])
    error(message('images:imfuse:invalidSpatiallyReferencedSyntax','imref2d'));
end

spatialRef3DPositions   = cellfun(@(c) isa(c,'imref3d'), varargin);
if any(spatialRef3DPositions)
    error(message('images:imfuse:imref3dSpecified','imref3d'));
end

Aref = varargin{2};
Bref = varargin{4};
varargin([2 4]) = [];

end



