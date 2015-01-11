function [ min_dist,max_dist ] = find_minDist( trD_n )
%FIND_MINDIST Summary of this function goes here
%   Detailed explanation goes here

inner_dist=self_sqrDist(trD_n);
tri_inner_dist=triu(inner_dist,1);

max_dist=max(tri_inner_dist(:));
tri_inner_dist(tri_inner_dist==0)=max_dist*10;
min_dist=min(tri_inner_dist(:));




end

