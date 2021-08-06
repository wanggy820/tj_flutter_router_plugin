package com.tojoy.router;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class _TJRouter {
	public static void register(String className, String url) {
		try {
			Class TJRouter = Class.forName("com.tojoy.tj_flutter_router_plugin.TJRouter");
			try {
				Method method = TJRouter.getDeclaredMethod("register", String.class, String.class);
				try {
					method.invoke(null, className, url);
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
			} catch (NoSuchMethodException e) {
				e.printStackTrace();
			};
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}
}
