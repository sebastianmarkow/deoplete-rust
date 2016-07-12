"""Rust completion via racer"""
import re

from .base import Base
# from deoplete.util import error


class Source(Base):
    """Deoplete Rust source"""

    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'Rust'
        self.mark = '[Rust]'
        self.filetypes = ['go']
        self.input_pattern = r'(\.|::)\w*'  # XXX(SK): words with digits?
        self.rank = 500

        self._racer = self.vim.funcs.executable(
            self.vim.eval('deoplete#sources#rust#racer_binary')
        )

        self._rust_re = re.compile(r'\w*$')  # XXX(SK): words with digits?

    def get_complete_position(self, ctx):
        """Missing"""
        if not self._racer:
            return -1

        method = self._rust_re.search(ctx['input'])
        return method.start() if method else -1

    def gather_candidates(self, ctx):
        """Missing"""
        pass
