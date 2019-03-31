package com.mapper;

import com.model.Spgys;

import java.util.List;

import org.apache.ibatis.annotations.Param;

public interface SpgysMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_spgys
     *
     * @mbggenerated
     */
    int deleteByPrimaryKey(Integer spgysId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_spgys
     *
     * @mbggenerated
     */
    int insert(Spgys record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_spgys
     *
     * @mbggenerated
     */
    Spgys selectByPrimaryKey(Integer spgysId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_spgys
     *
     * @mbggenerated
     */
    List<Spgys> selectAll(@Param("spgys")Spgys record,@Param("page")int page,@Param("rows")int rows, @Param("sdate")String sdate, @Param("edate")String edate);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_spgys
     *
     * @mbggenerated
     */
    int updateByPrimaryKey(Spgys record);
}