/*
 * Copyright 2018-2023 datagear.tech
 *
 * This file is part of DataGear.
 *
 * DataGear is free software: you can redistribute it and/or modify it under the terms of
 * the GNU Lesser General Public License as published by the Free Software Foundation,
 * either version 3 of the License, or (at your option) any later version.
 *
 * DataGear is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
 * without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License along with DataGear.
 * If not, see <https://www.gnu.org/licenses/>.
 */

package org.datagear.web.config;

import org.datagear.web.util.DirectoryCleaner;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

/**
 * 计划任务配置。
 * 
 * @author datagear@163.com
 *
 */
@Configuration
@EnableScheduling
public class SchedulingConfig
{
	private CoreConfig coreConfig;

	@Autowired
	public SchedulingConfig(CoreConfig coreConfig)
	{
		this.coreConfig = coreConfig;
	}

	public CoreConfig getCoreConfig()
	{
		return coreConfig;
	}

	public void setCoreConfig(CoreConfig coreConfig)
	{
		this.coreConfig = coreConfig;
	}

	@Bean
	public DirectoryCleaner tempDirectoryCleaner()
	{
		int expiredMinutes = this.coreConfig.getApplicationProperties()
				.getCleanTempDirectoryExpiredMinutes();

		DirectoryCleaner bean = new DirectoryCleaner(this.coreConfig.tempDirectory(), expiredMinutes);
		return bean;
	}

	@Scheduled(cron = "${cleanTempDirectory.interval}")
	public void cleanTempDirectory()
	{
		this.tempDirectoryCleaner().clean();
	}
}
