// --------------------------------------------------------------------------------------------------------------------
// <copyright file="MaterialSimpleToggleDrawer.cs" company="Supyrb">
//   Copyright (c) 2019 Supyrb. All rights reserved.
// </copyright>
// <author>
//   Johannes Deml
//   public@deml.io
// </author>
// --------------------------------------------------------------------------------------------------------------------

using System;
using UnityEditor;
using UnityEngine;

namespace Supyrb
{
	/// <summary>
	/// Material Property Drawer [SimpleToggle] behaves like [Toggle] but does not create any shader variants
	/// </summary>
	public class MaterialSimpleToggleDrawer : MaterialPropertyDrawer
	{
		public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
		{
			var value = prop.floatValue > 0.0f;

			EditorGUI.BeginChangeCheck();
			EditorGUI.showMixedValue = prop.hasMixedValue;

			value = EditorGUI.Toggle(position, label, value);

			EditorGUI.showMixedValue = false;
			if (EditorGUI.EndChangeCheck())
			{
				prop.floatValue = value ? 1.0f : 0.0f;
			}
		}
	}
}