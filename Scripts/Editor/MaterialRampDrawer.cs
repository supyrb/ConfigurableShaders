// --------------------------------------------------------------------------------------------------------------------
// <copyright file="MaterialRampDrawer.cs" company="Supyrb">
//   Copyright (c) 2020 Supyrb. All rights reserved.
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
	/// Draws a texture property so you can see the texture in a long bar as you would which for with a color ramp
	/// </summary>
	public class MaterialRampDrawer : MaterialPropertyDrawer
	{
		private static readonly Color BorderColor = new Color(0f, 0f, 0f, 1f);
		private const float paddingTexField = 4f;
		
		public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
		{
			EditorGUI.BeginChangeCheck();
			EditorGUI.showMixedValue = prop.hasMixedValue;
			Texture tex = prop.textureValue;
			
			float textWidth = EditorGUIUtility.currentViewWidth * 0.25f;
			float textureDrawingWidth = EditorGUIUtility.currentViewWidth * 0.45f;
			EditorGUI.LabelField(new Rect(position.x, position.y, textWidth, position.height), label);
			var texFieldInset = textWidth + textureDrawingWidth + paddingTexField;
			tex = (Texture) EditorGUI.ObjectField(new Rect(position.x + texFieldInset, position.y, position.width - texFieldInset, position.height), tex, typeof(Texture2D), false);
			
			if (tex != null)
			{
				Rect previewTextureRect = DrawBlackBorder(new Rect(position.x + textWidth, position.y, textureDrawingWidth, position.height));
				EditorGUI.DrawPreviewTexture(previewTextureRect, tex);
			}

			EditorGUI.showMixedValue = false;
			if (EditorGUI.EndChangeCheck())
			{
				prop.textureValue = tex;
			}
		}

		public Rect DrawBlackBorder(Rect rect)
		{
			EditorGUI.DrawRect(rect, BorderColor);
			return new Rect(rect.x + 1, rect.y + 1, rect.width - 2, rect.height - 2);
		}

		public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor)
		{
			return EditorGUIUtility.singleLineHeight;
		}
	}
}