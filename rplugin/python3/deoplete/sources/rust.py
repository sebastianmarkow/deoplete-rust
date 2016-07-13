"""Rust completion via racer"""
import os
import re
import subprocess
import tempfile

from .base import Base
from deoplete.logger import getLogger


logger = getLogger('rust')

class Source(Base):
    """Deoplete Rust source"""

    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'Rust'
        self.mark = '[Rust]'
        self.filetypes = ['rust']
        self.input_pattern = r'(\.|::)\w*'  # XXX(SK): words with digits?
        self.rank = 500
        self.debug_enabled = True

        self.__racer = self.vim.vars.get(
            'deoplete#sources#rust#racer_binary',
            ''
        )

        if 'RUST_SRC_PATH' not in os.environ:
            rust_path = self.vim.vars.get('deoplete#sources#rust#rust_source_path')
            if rust_path != '':
                os.environ['RUST_SRC_PATH'] = rust_path

        logger.debug(self.__racer)
        logger.debug(os.environ.get('RUST_SRC_PATH'))

        self.__rust_re = re.compile(r'\w*$')  # XXX(SK): words with digits?

    def get_complete_position(self, ctx):
        """Missing"""
        if not self.__check_binary():
            logger.debug("binary failed")
            return -1

        method = self.__rust_re.search(ctx['input'])
        if method:
            m = method.start()
            return m
        else:
            return -1

        # return method.start() if method else -1

    def gather_candidates(self, ctx):
        """Missing"""

        candidates = []

        lines = self.__retrieve(ctx)
        matches = [line[6:] for line in lines if line.startswith('MATCH')]

        for match in matches:
            tokens = match.split(',')
            candidate = {
                'word': tokens[0],
                'kind': tokens[4],
                'abbr': tokens[5],
                'dup': 1,
            }
            candidates.append(candidate)

        return candidates

    def __retrieve(self, ctx):

        content = self.vim.current.buffer
        line = self.vim.current.window.cursor[0]
        column = ctx['complete_position']

        logger.debug(content[0])

        with tempfile.NamedTemporaryFile(mode='w') as buf:
            buf.write('\n'.join(content))
            buf.flush()

            args = [
                self.__racer,
                'complete',
                line,
                column,
                buf.name
            ]

            logger.debug(args)
            logger.debug(os.environ.get('RUST_SRC_PATH'))

            env = os.environ.copy()

            proc = subprocess.run(["ls", "-l"])
            proc.kill()
            logger.debug('after')

        return []

    def __check_binary(self):
        return os.path.isfile(self.__racer) and os.environ.get('RUST_SRC_PATH')
