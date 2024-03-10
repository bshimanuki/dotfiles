import glob
import os
import os.path
from pathlib import Path
import logging
import re

C_BASE_FLAGS = [
	'-Wall',
	'-Wextra',
	'-Werror',
	'-Wno-long-long',
	'-Wno-variadic-macros',
	'-fexceptions',
	'-ferror-limit=10000',
	'-DDEBUG',
	'-std=c11',
	'-I/usr/lib/',
	'-I/usr/include/',
]

CPP_BASE_FLAGS = [
	'-Wall',
	'-Wextra',
	'-Wno-long-long',
	'-Wno-variadic-macros',
	'-fexceptions',
	'-ferror-limit=10000',
	'-DDEBUG',
	'-std=c++1z',
	'-xc++',
	'-I/usr/lib/',
	'-I/usr/include/',
]

C_SOURCE_EXTENSIONS = [
	'.c',
]

CPP_SOURCE_EXTENSIONS = [
	'.cpp',
	'.cxx',
	'.cc',
	'.m',
	'.mm',
]

SOURCE_DIRECTORIES = [
	'src',
	'lib',
]

HEADER_EXTENSIONS = [
	'.h',
	'.hxx',
	'.hpp',
	'.hh',
]

HEADER_DIRECTORIES = [
	'include',
	'inc',
]

INCLUDE_DIRECTORIES = [
	'include',
	'external/*',
	'external/*/include',
	'/usr/include',
	# '/usr/include/*',
	'include',
	'inc',
	'include/*',
	'inc/*',
	'*/include',
	'*/inc',
]


def is_source_file(filename):
	extension = os.path.splitext(filename)[1]
	return extension in C_SOURCE_EXTENSIONS + CPP_SOURCE_EXTENSIONS


def is_header_file(filename):
	extension = os.path.splitext(filename)[1]
	return extension in HEADER_EXTENSIONS


def get_project_root(filename):
	if os.path.exists(os.path.join(filename, '.git')):
		return filename
	parent = os.path.dirname(filename)
	if parent == filename:
		return None
	return get_project_root(parent)


def find_nearest(path, target, suffix_directory=None):
	candidate = os.path.join(path, target)
	if(os.path.isfile(candidate) or os.path.isdir(candidate)):
		logging.info("Found nearest " + target + " at " + candidate)
		return candidate

	parent = os.path.dirname(os.path.abspath(path))
	if parent == path:
		return None

	if suffix_directory:
		candidate = os.path.join(parent, suffix_directory, target)
		if(os.path.isfile(candidate) or os.path.isdir(candidate)):
			logging.info("Found nearest " + target + " in build folder at " + candidate)
			return candidate

	return find_nearest(parent, target, suffix_directory=suffix_directory)


def get_include_flags(root):
	flags = []
	for include_name in INCLUDE_DIRECTORIES:
		include_path = find_nearest(root, include_name)
		if include_path:
			flags = flags + ["-I" + include_path]
		else:
			project_root = get_project_root(root)
			for top in (os.path.abspath('.'), project_root):
				if top is not None:
					for real_path in glob.glob(os.path.join(top, include_name)):
						if os.path.isdir(real_path):
							flags = flags + ["-I" + real_path]
	return flags


def get_compilation_database_dir(root, compilation_database_directory):
	compilation_db_path = find_nearest(
		root, 'compile_commands.json', suffix_directory=compilation_database_directory)
	if compilation_db_path:
		compilation_db_dir = os.path.dirname(compilation_db_path)
		return compilation_db_dir
	return None


def Settings(**kwargs):
	filename = Path(kwargs['filename'])
	language = kwargs['language']
	client_data = kwargs['client_data']
	settings = {}
	settings['do_cache'] = True

	sys_path = client_data.get('g:ycm_python_sys_path')
	compilation_database_directory = client_data.get('g:ycm_compilation_database_directory')
	interpreter_path = client_data.get('g:ycm_default_python_interpreter_path')
	if not interpreter_path:
		# search for .venv
		for d in filename.parents:
			maybe_interpreter_path = d / '.venv' / 'bin' / 'python'
			if maybe_interpreter_path.is_file():
				interpreter_path = maybe_interpreter_path
				break
	if not interpreter_path:
		interpreter_path = client_data.get('g:ycm_python_interpreter_path')
	if interpreter_path:
		settings['interpreter_path'] = interpreter_path
	if sys_path:
		settings['sys_path'] = sys_path

	if language == 'cfamily':
		ls_settings = {}
		settings['ls'] = ls_settings
		root = os.path.realpath(filename)

		compilation_db_dir = get_compilation_database_dir(root, compilation_database_directory)
		if compilation_db_dir:
			ls_settings['compilationDatabasePath'] = compilation_db_dir

		if is_source_file(filename):
			extension = os.path.splitext(filename)[1]
			if extension in C_SOURCE_EXTENSIONS:
				base_flags = C_BASE_FLAGS
			else:
				base_flags = CPP_BASE_FLAGS
		elif is_header_file(filename):
			base_flags = CPP_BASE_FLAGS
		include_flags = get_include_flags(root)
		final_flags = base_flags + include_flags

		ls_settings['fallbackFlags'] = final_flags

	if language == 'rust':
		settings['ls'] = {
			'cargo': {
				'loadOutDirsFromCheck': True,
			},
			'experimental': {
				'procAttrMacros': True,
			},
			'procMacro': {
				'enable': True,
			},
		}

	return settings
