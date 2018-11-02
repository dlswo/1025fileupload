package org.injae.mapper;

import java.util.List;

public interface CommonMapper<VO, PK> {
	
	public List<VO> getList(PK pk);
	
	public int insert(VO vo);
	
	public VO read(PK pk);
	
	public int delete(PK pk);
	
	public int update(VO vo);
	
	public int count();
	
	public List<VO> search(PK pk);
	
	public int insertSelectKey(VO vo);
	
	public List<VO> findByBno(PK pk);
	
	public int deleteAll(int bno);
	
	public List<VO> getListWithPaging(PK pk);
	
}
