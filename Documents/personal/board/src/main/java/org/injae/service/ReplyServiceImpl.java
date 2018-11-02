package org.injae.service;

import java.util.List;

import org.injae.domain.BoardAttachVO;
import org.injae.domain.Param;
import org.injae.domain.ReplyVO;
import org.injae.mapper.BoardMapper;
import org.injae.mapper.ReplyMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import lombok.AllArgsConstructor;
import lombok.Setter;

@Service
public class ReplyServiceImpl implements ReplyService {

	@Setter(onMethod_= @Autowired)
	private ReplyMapper mapper;

	@Override
	public List<ReplyVO> getList(Param pk) {
		return mapper.getListWithPaging(pk);
	}

	@Override
	public int register(ReplyVO vo) {
		return mapper.insert(vo);
	}

	@Override
	public ReplyVO read(Param pk) {
		return mapper.read(pk);
	}

	@Override
	public int remove(Param pk) {
		return mapper.delete(pk);
	}

	@Override
	public int modify(ReplyVO vo) {
		return mapper.update(vo);
	}

	@Override
	public int getTotal() {
		return 0;
	}

	@Override
	public List<BoardAttachVO> getAttachList(Param pk) {
		return null;
	}


}
