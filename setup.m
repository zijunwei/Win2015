function setup(id)
if id==1
loc='zjlocal';
elseif id==2
loc='zjserver';
end

fprintf	('This is runing on %s \n',loc);

addpath_recurse('./voc-release5');
addpath_recurse('./MyGradFuncs');
run('./vlfeat/toolbox/vl_setup.m');

end
