package org.injae.service;

import java.util.List;

import org.injae.domain.Board;
import org.injae.domain.BoardAttachVO;
import org.injae.domain.Param;
import org.injae.mapper.BoardAttachMapper;
import org.injae.mapper.BoardMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class BoardServiceImpl implements BoardService {
	
	@Setter(onMethod_= @Autowired)
	private BoardMapper mapper;
	
	@Setter(onMethod_= @Autowired)
	private BoardAttachMapper attachMapper;

	@Override
	public List<Board> getList(Param param) {
		return mapper.getList(param);
	}

	@Transactional
	@Override
	public int register(Board board) {
		
		mapper.insertSelectKey(board);
		
		if(board.getAttachList() == null || board.getAttachList().size() <= 0) {
			return -1;
		}
		
		board.getAttachList().forEach(attach ->{
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
		
		return 1;
		
	}

	@Override
	public Board read(Param param) {
		return mapper.read(param);
	}

	@Transactional
	@Override
	public int remove(Param param) {
		
		attachMapper.deleteAll(param.getBno());
		
		return mapper.delete(param);
	}

	@Override
	public int modify(Board board) {
		
		attachMapper.deleteAll(board.getBno());
		
		int result = mapper.update(board);
		
		if(result == 1 || board.getAttachList().size() > 0) {
			
			board.getAttachList().forEach(attach -> {
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
			
		}
		
		return result;
	}

	@Override
	public int getTotal() {
		return mapper.count();
	}

	@Override
	public List<BoardAttachVO> getAttachList(Param param) {
		return attachMapper.findByBno(param);
	}
	
}
