"""Rust completion via Racer"""

import os
import re
import subprocess
import tempfile
import platform

from .base import Base
from deoplete.logger import getLogger

logger = getLogger('rust')

VAR_RACER_BINARY = 'deoplete#sources#rust#racer_binary'
VAR_RUST_SOURCE = 'deoplete#sources#rust#rust_source_path'
VAR_DUPLICATION = 'deoplete#sources#rust#show_duplicates'

class Source(Base):
    """Deoplete Rust source"""
    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'rust'
        self.mark = '[Rust]'
        self.filetypes = ['rust']
        self.input_pattern = r'(\.|::)\w*'
        self.rank = 500

        self.__racer = self.vim.vars.get(VAR_RACER_BINARY)
        self.__dup = self.vim.vars.get(VAR_DUPLICATION)
        self.__encoding = self.vim.eval('&encoding')
        self.__rust_re = re.compile(r'\w*$|(?<=")[./\-\w]*$')

        if 'RUST_SRC_PATH' not in os.environ:
            rust_path = self.vim.vars.get(VAR_RUST_SOURCE)
            if rust_path:
                os.environ['RUST_SRC_PATH'] = rust_path

    def get_complete_position(self, ctx):
        """Missing"""
        if not self.__check_binary():
            return -1

        method = self.__rust_re.search(ctx['input'])
        return method.start() if method else -1

    def gather_candidates(self, ctx):
        """Missing"""
        candidates = []

        lines = self.__retrieve()
        matches = [line[6:] for line in lines if line.startswith('MATCH')]

        if not bool(self.__dup):
            matches = set(matches)

        for match in matches:
            tokens = match.split(",")
            candidate = {
                'word': tokens[0],
                'kind': tokens[4],
                'menu': tokens[5],
                'info': ','.join(tokens[5:]),
                'dup': self.__dup,
            }
            candidates.append(candidate)

        return candidates

    def __retrieve(self):
        """Missing"""
        content = self.vim.current.buffer
        line, column = self.vim.current.window.cursor

        with tempfile.NamedTemporaryFile(mode='w') as buf:
            buf.write("\n".join(content))
            buf.flush()

            args = [
                self.__racer,
                'complete',
                str(line),
                str(column),
                self.__escape_path(content.name),
                self.__escape_path(buf.name)
            ]

            results = []

            try:
                # NOTE: needs to avoid the list form of calling 'check_output'
                # because quotes was NOT preserved. See StackOverlow post.
                # https://stackoverflow.com/a/39096422/3325787
                cmd = " ".join(args)
                results = subprocess.check_output(cmd, shell=True) \
                    .decode(self.__encoding).splitlines()
            except Exception:
                pass

            return results

    def __escape_path(self, path):
        """
        Handles Cygwin case.

        path(String): path to escape.
        Returns: string of new path to use.
        """
        if "cygwin" not in platform.system().lower():
            return path
        args = [
            "cygpath", "--windows", path
        ]
        try:
            results = subprocess.check_output(args) \
                .decode(self.__encoding).splitlines()
        except Exception:
            pass
        # In the error path, best-effort is to try 'path'.
        if results is None or len(results) == 0:
          return path
        # TODO: find something like vim's fnameescape instead of just
        # surrounding with quotes.
        return '"' + results[0] + '"'

    def __check_binary(self):
        """Missing"""
        return os.path.isfile(self.__racer) and os.environ.get('RUST_SRC_PATH')
