package org.injae.service;

import java.util.List;

import org.injae.domain.BoardAttachVO;

public interface CommonService<VO, PK> {

	public List<VO> getList(PK pk);
	
	public int register(VO vo);

	public VO read(PK pk);
	
	public int remove(PK pk);
	
	public int modify(VO vo);
	
	public int getTotal();
	
	public List<BoardAttachVO> getAttachList(PK pk);
	
}
